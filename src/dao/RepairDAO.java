package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import model.Car;
import model.Customer;
import model.Part;
import model.Repair;
import model.SaleStaff;
import model.Service;
import model.Technician;
import model.UsedPart;
import model.UsedService;

/**
 * Lớp truy xuất dữ liệu bảng tblRepair (kèm tblUsedService, tblUsedPart).
 */
public class RepairDAO extends DAO {

    public RepairDAO() {
        super();
    }

    /**
     * Lấy lượt sửa chữa chưa thanh toán (mới nhất) của một khách hàng,
     * kèm xe, khách hàng, nhân viên nhận xe,
     * danh sách dịch vụ đã dùng và danh sách phụ tùng đã dùng.
     * @param idCustomer id của khách hàng được chọn
     * @return lượt sửa chữa chưa thanh toán, hoặc null nếu khách không có
     */
    public Repair getUnpaidRepair(int idCustomer) {
        Repair repair = null;
        String sql = "SELECT r.id, r.receiveDate, r.status, "
                + "car.id AS carId, car.licensePlate, car.brand, car.model, "
                + "c.id AS customerId, c.fullName AS customerName, c.tel, c.address, c.email, "
                + "m.id AS staffId, m.fullName AS staffName, m.position "
                + "FROM tblRepair r "
                + "JOIN tblCar car ON r.tblCarid = car.id "
                + "JOIN tblCustomer c ON car.tblCustomerid = c.id "
                + "JOIN tblMember m ON r.tblMemberid = m.id "
                + "WHERE c.id = ? AND r.status = ? "
                + "ORDER BY r.receiveDate DESC LIMIT 1";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idCustomer);
            ps.setString(2, Repair.STATUS_UNPAID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                // 1. khách hàng
                Customer customer = new Customer();
                customer.setId(rs.getInt("customerId"));
                customer.setFullName(rs.getString("customerName"));
                customer.setTel(rs.getString("tel"));
                customer.setAddress(rs.getString("address"));
                customer.setEmail(rs.getString("email"));

                // 2. xe (chứa khách hàng)
                Car car = new Car();
                car.setId(rs.getInt("carId"));
                car.setLicensePlate(rs.getString("licensePlate"));
                car.setBrand(rs.getString("brand"));
                car.setModel(rs.getString("model"));
                car.setCustomer(customer);

                // 3. nhân viên bán hàng nhận xe
                SaleStaff staff = new SaleStaff();
                staff.setId(rs.getInt("staffId"));
                staff.setFullName(rs.getString("staffName"));
                staff.setPosition(rs.getString("position"));

                // 4. lượt sửa chữa (chứa xe, nhân viên, dịch vụ và phụ tùng đã dùng)
                repair = new Repair();
                repair.setId(rs.getInt("id"));
                repair.setReceiveDate(rs.getDate("receiveDate"));
                repair.setStatus(rs.getString("status"));
                repair.setCar(car);
                repair.setSaleStaff(staff);
                repair.setUsedServices(getUsedServices(repair.getId()));
                repair.setUsedParts(getUsedParts(repair.getId()));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return repair;
    }

    /**
     * Lấy danh sách dịch vụ đã dùng của một lượt sửa chữa.
     */
    private ArrayList<UsedService> getUsedServices(int idRepair) throws Exception {
        ArrayList<UsedService> result = new ArrayList<UsedService>();
        String sql = "SELECT us.id, us.quantity, us.price, "
                + "s.id AS serviceId, s.name, s.price AS servicePrice, s.description, "
                + "t.id AS technicianId, t.fullName AS technicianName "
                + "FROM tblUsedService us "
                + "JOIN tblService s ON us.tblServiceid = s.id "
                + "LEFT JOIN tblTechnician t ON us.tblTechnicianid = t.id "
                + "WHERE us.tblRepairid = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, idRepair);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Service service = new Service();
            service.setId(rs.getInt("serviceId"));
            service.setName(rs.getString("name"));
            service.setPrice(rs.getFloat("servicePrice"));
            service.setDescription(rs.getString("description"));

            Technician technician = null;          // có thể chưa phân công
            if (rs.getInt("technicianId") != 0) {
                technician = new Technician();
                technician.setId(rs.getInt("technicianId"));
                technician.setFullName(rs.getString("technicianName"));
            }

            UsedService us = new UsedService();
            us.setId(rs.getInt("id"));
            us.setQuantity(rs.getInt("quantity"));
            us.setPrice(rs.getFloat("price"));      // giá tại thời điểm sử dụng
            us.setAmount(us.getQuantity() * us.getPrice());
            us.setService(service);
            us.setTechnician(technician);
            result.add(us);
        }
        return result;
    }

    /**
     * Lấy danh sách phụ tùng đã dùng của một lượt sửa chữa.
     */
    private ArrayList<UsedPart> getUsedParts(int idRepair) throws Exception {
        ArrayList<UsedPart> result = new ArrayList<UsedPart>();
        String sql = "SELECT up.id, up.quantity, up.price, "
                + "p.id AS partId, p.name, p.price AS partPrice, p.unit, p.stockQuantity, p.description "
                + "FROM tblUsedPart up "
                + "JOIN tblPart p ON up.tblPartid = p.id "
                + "WHERE up.tblRepairid = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, idRepair);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Part part = new Part();
            part.setId(rs.getInt("partId"));
            part.setName(rs.getString("name"));
            part.setPrice(rs.getFloat("partPrice"));
            part.setUnit(rs.getString("unit"));
            part.setStockQuantity(rs.getInt("stockQuantity"));
            part.setDescription(rs.getString("description"));

            UsedPart up = new UsedPart();
            up.setId(rs.getInt("id"));
            up.setQuantity(rs.getInt("quantity"));
            up.setPrice(rs.getFloat("price"));      // giá tại thời điểm sử dụng
            up.setAmount(up.getQuantity() * up.getPrice());
            up.setPart(part);
            result.add(up);
        }
        return result;
    }
}
