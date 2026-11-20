package model;

import java.io.Serializable;

/**
 * Một dòng dịch vụ đã dùng trong lượt sửa chữa. price là đơn giá tại thời điểm sử dụng.
 */
public class UsedService implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int quantity;
    private float price;
    private float amount;
    private Service service;
    private Technician technician;

    public UsedService() {
        super();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public float getAmount() {
        return amount;
    }

    public void setAmount(float amount) {
        this.amount = amount;
    }

    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
    }

    public Technician getTechnician() {
        return technician;
    }

    public void setTechnician(Technician technician) {
        this.technician = technician;
    }
}
