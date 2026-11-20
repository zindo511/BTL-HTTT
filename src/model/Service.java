package model;

import java.io.Serializable;

/**
 * Dịch vụ của gara.
 */
public class Service implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String name;
    private float price;
    private String description;

    public Service() {
        super();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
