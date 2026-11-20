package model;

import java.io.Serializable;
import java.util.Date;

/**
 * Hoá đơn thanh toán của một lượt sửa chữa.
 */
public class Bill implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private Date paymentDate;
    private float totalAmount;
    private Repair repair;
    private SaleStaff saleStaff;

    public Bill() {
        super();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }

    public float getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(float totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Repair getRepair() {
        return repair;
    }

    public void setRepair(Repair repair) {
        this.repair = repair;
    }

    public SaleStaff getSaleStaff() {
        return saleStaff;
    }

    public void setSaleStaff(SaleStaff saleStaff) {
        this.saleStaff = saleStaff;
    }
}
