package model;

import java.io.Serializable;

/**
 * Nhân viên của gara. Kế thừa Member, thêm vị trí công việc (position).
 */
public abstract class Staff extends Member {
    private static final long serialVersionUID = 1L;

    private String position;

    public Staff() {
        super();
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }
}
