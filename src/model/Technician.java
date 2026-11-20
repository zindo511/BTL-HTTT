package model;

import java.io.Serializable;

/**
 * Nhân viên kỹ thuật. Không đăng nhập hệ thống nên không kế thừa Member.
 */
public class Technician implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String fullName;
    private String tel;
    private String address;
    private String specialty;

    public Technician() {
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

    public String getSpecialty() {
        return specialty;
    }

    public void setSpecialty(String specialty) {
        this.specialty = specialty;
    }
}
