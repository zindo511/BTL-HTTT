package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

import model.Staff;

/**
 * Lớp truy xuất dữ liệu bảng tblMember (dùng cho chức năng đăng nhập).
 */
public class MemberDAO extends DAO {

    public MemberDAO() {
        super();
    }

    /**
     * Kiểm tra đăng nhập của nhân viên.
     * Nếu đúng tên đăng nhập và mật khẩu thì set thêm các thuộc tính
     * id, fullName, birthday, address, email, tel, position vào đối tượng nv.
     * @param nv nhân viên đã được set username và password
     * @return true nếu đăng nhập đúng, false nếu sai
     */
    public boolean checkLogin(Staff nv) {
        boolean kq = false;
        String sql = "SELECT * FROM tblMember WHERE username = ? AND password = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, nv.getUsername());
            ps.setString(2, nv.getPassword());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                // đóng gói thông tin vào đối tượng thực thể
                nv.setId(rs.getInt("id"));
                nv.setFullName(rs.getString("fullName"));
                nv.setBirthday(rs.getDate("birthday"));
                nv.setAddress(rs.getString("address"));
                nv.setEmail(rs.getString("email"));
                nv.setTel(rs.getString("tel"));
                nv.setPosition(rs.getString("position"));
                kq = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            kq = false;
        }
        return kq;
    }
}
