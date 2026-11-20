package model;

import java.io.Serializable;
import java.util.Date;
import java.util.ArrayList;

/**
 * Lượt sửa chữa: một lần xe vào gara, từ lúc nhận xe đến lúc thanh toán.
 */
public class Repair implements Serializable {
    private static final long serialVersionUID = 1L;

    /** Trạng thái của lượt sửa chữa. */
    public static final String STATUS_UNPAID = "unpaid";
    public static final String STATUS_PAID = "paid";

    private int id;
    private Date receiveDate;
    private String status;
    private Car car;
    private SaleStaff saleStaff;
    private ArrayList<UsedService> usedServices;
    private ArrayList<UsedPart> usedParts;

    public Repair() {
        super();
        usedServices = new ArrayList<UsedService>();
        usedParts = new ArrayList<UsedPart>();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getReceiveDate() {
        return receiveDate;
    }

    public void setReceiveDate(Date receiveDate) {
        this.receiveDate = receiveDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Car getCar() {
        return car;
    }

    public void setCar(Car car) {
        this.car = car;
    }

    public SaleStaff getSaleStaff() {
        return saleStaff;
    }

    public void setSaleStaff(SaleStaff saleStaff) {
        this.saleStaff = saleStaff;
    }

    public ArrayList<UsedService> getUsedServices() {
        return usedServices;
    }

    public void setUsedServices(ArrayList<UsedService> usedServices) {
        this.usedServices = usedServices;
    }

    public ArrayList<UsedPart> getUsedParts() {
        return usedParts;
    }

    public void setUsedParts(ArrayList<UsedPart> usedParts) {
        this.usedParts = usedParts;
    }

    /**
     * Tính tổng tiền của lượt sửa chữa = tổng thành tiền các dịch vụ + phụ tùng đã dùng.
     * Tổng tiền là thuộc tính dẫn xuất nên không lưu trong CSDL mà tính lại khi cần.
     */
    public float getTotalAmount() {
        float total = 0;
        for (UsedService us : usedServices) total += us.getQuantity() * us.getPrice();
        for (UsedPart up : usedParts) total += up.getQuantity() * up.getPrice();
        return total;
    }
}
