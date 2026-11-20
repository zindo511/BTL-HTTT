package model;

import java.io.Serializable;

/**
 * Xe của khách hàng. Chứa thông tin chủ xe (customer).
 */
public class Car implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String licensePlate;
    private String brand;
    private String model;
    private Customer customer;

    public Car() {
        super();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }
}
