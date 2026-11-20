package dao;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * Lớp cha của mọi lớp DAO.
 * Giữ một kết nối CSDL dùng chung cho toàn hệ thống (static) để tiết kiệm tài nguyên.
 */
public class DAO {
    protected static Connection con;

    public DAO() {
        if (con == null) {
            String dbUrl = "jdbc:mysql://localhost:3306/garaman?autoReconnect=true&useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=UTF-8";
            String dbClass = "com.mysql.cj.jdbc.Driver";
            try {
                Class.forName(dbClass);
                con = DriverManager.getConnection(dbUrl, "root", "123456");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
