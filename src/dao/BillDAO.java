package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;

import model.Bill;
import model.Repair;
import model.UsedPart;
import model.UsedService;

/**
 * Lớp truy xuất dữ liệu bảng tblBill.
 */
public class BillDAO extends DAO {

    public BillDAO() {
        super();
    }

    /**
     * Lưu hoá đơn thanh toán. Bốn bước sau chạy trong một giao dịch (transaction),
     * một bước lỗi thì huỷ toàn bộ (rollback):
     *   1. Lưu các dịch vụ bổ sung (dòng có id = 0, chưa có trong CSDL).
     *   2. Lưu các phụ tùng bổ sung và trừ số lượng tồn kho.
     *   3. Lưu hoá đơn vào tblBill.
     *   4. Chuyển trạng thái lượt sửa chữa sang "đã thanh toán".
     * @param bill hoá đơn đã được set repair, saleStaff, paymentDate
     * @return true nếu lưu thành công, false nếu lỗi
     */
    public boolean saveBill(Bill bill) {
        boolean ok = false;
        Repair repair = bill.getRepair();
        try {
            con.setAutoCommit(false);

            for (UsedService us : repair.getUsedServices()) {
                if (us.getId() == 0) saveNewUsedService(repair.getId(), us);   // bước 1
            }
            for (UsedPart up : repair.getUsedParts()) {
                if (up.getId() == 0) saveNewUsedPart(repair.getId(), up);      // bước 2
            }
            insertBill(bill);                                                  // bước 3
            updateRepairStatus(repair.getId(), Repair.STATUS_PAID);            // bước 4

            con.commit();
            repair.setStatus(Repair.STATUS_PAID);
            ok = true;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                con.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return ok;
    }

    /** Bước 1: thêm một dòng dịch vụ bổ sung vào tblUsedService. */
    private void saveNewUsedService(int idRepair, UsedService us) throws Exception {
        String sql = "INSERT INTO tblUsedService(quantity, price, tblRepairid, tblServiceid, tblTechnicianid) "
                   + "VALUES(?, ?, ?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        ps.setInt(1, us.getQuantity());
        ps.setFloat(2, us.getPrice());
        ps.setInt(3, idRepair);
        ps.setInt(4, us.getService().getId());
        if (us.getTechnician() != null) {
            ps.setInt(5, us.getTechnician().getId());
        } else {
            ps.setNull(5, Types.INTEGER);    // chưa phân công nhân viên kỹ thuật
        }
        ps.executeUpdate();
        us.setId(getGeneratedId(ps));
    }

    /** Bước 2: thêm một dòng phụ tùng bổ sung vào tblUsedPart và trừ tồn kho. */
    private void saveNewUsedPart(int idRepair, UsedPart up) throws Exception {
        String sql = "INSERT INTO tblUsedPart(quantity, price, tblRepairid, tblPartid) VALUES(?, ?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        ps.setInt(1, up.getQuantity());
        ps.setFloat(2, up.getPrice());
        ps.setInt(3, idRepair);
        ps.setInt(4, up.getPart().getId());
        ps.executeUpdate();
        up.setId(getGeneratedId(ps));

        String sqlStock = "UPDATE tblPart SET stockQuantity = stockQuantity - ? WHERE id = ?";
        PreparedStatement psStock = con.prepareStatement(sqlStock);
        psStock.setInt(1, up.getQuantity());
        psStock.setInt(2, up.getPart().getId());
        psStock.executeUpdate();
    }

    /** Bước 3: lưu hoá đơn (tổng tiền là thuộc tính dẫn xuất nên không lưu). */
    private void insertBill(Bill bill) throws Exception {
        String sql = "INSERT INTO tblBill(paymentDate, tblRepairid, tblMemberid) VALUES(?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        ps.setDate(1, new java.sql.Date(bill.getPaymentDate().getTime()));
        ps.setInt(2, bill.getRepair().getId());
        ps.setInt(3, bill.getSaleStaff().getId());
        ps.executeUpdate();
        bill.setId(getGeneratedId(ps));
    }

    /** Bước 4: cập nhật trạng thái lượt sửa chữa. */
    private void updateRepairStatus(int idRepair, String status) throws Exception {
        String sql = "UPDATE tblRepair SET status = ? WHERE id = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, status);
        ps.setInt(2, idRepair);
        ps.executeUpdate();
    }

    /** Lấy id tự tăng mà CSDL vừa sinh cho dòng mới thêm. */
    private int getGeneratedId(PreparedStatement ps) throws Exception {
        ResultSet key = ps.getGeneratedKeys();
        return key.next() ? key.getInt(1) : 0;
    }
}
