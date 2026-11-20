package model;

import java.io.Serializable;

/**
 * Một dòng phụ tùng đã dùng trong lượt sửa chữa. price là đơn giá tại thời điểm sử dụng.
 */
public class UsedPart implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int quantity;
    private float price;
    private float amount;
    private Part part;

    public UsedPart() {
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

    public Part getPart() {
        return part;
    }

    public void setPart(Part part) {
        this.part = part;
    }
}
