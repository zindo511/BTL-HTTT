package model;

import java.io.Serializable;

/**
 * Khách hàng của gara (không có tài khoản).
 */
public class Customer implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String fullName;
    private String tel;
    private String address;
    private String email;

    public Customer() {
        super();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
