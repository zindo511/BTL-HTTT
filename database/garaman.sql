-- CSDL GaraMan (theo sơ đồ CSDL đã thiết kế, bản gộp tblMember)
-- Chạy lại file này sẽ XOÁ database garaman cũ và tạo lại từ đầu với dữ liệu mẫu.
DROP DATABASE IF EXISTS garaman;
CREATE DATABASE garaman CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE garaman;

CREATE TABLE tblMember (
  id INT(10) PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  fullName VARCHAR(255),
  birthday DATE,
  address VARCHAR(255),
  email VARCHAR(255),
  tel VARCHAR(255),
  position VARCHAR(255)
);

CREATE TABLE tblTechnician (
  id INT(10) PRIMARY KEY AUTO_INCREMENT,
  fullName VARCHAR(255),
  tel VARCHAR(255),
  address VARCHAR(255),
  specialty VARCHAR(255)
);

CREATE TABLE tblCustomer (
  id INT(10) PRIMARY KEY AUTO_INCREMENT,
  fullName VARCHAR(255),
  tel VARCHAR(255),
  address VARCHAR(255),
  email VARCHAR(255)
);

CREATE TABLE tblSupplier (
  id INT(10) PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255),
  address VARCHAR(255),
  tel VARCHAR(255),
  email VARCHAR(255),
  description VARCHAR(255)
);

CREATE TABLE tblCar (
  id INT(10) PRIMARY KEY AUTO_INCREMENT,
  licensePlate VARCHAR(255),
  brand VARCHAR(255),
  model VARCHAR(255),
  tblCustomerid INT(10) NOT NULL,
  FOREIGN KEY (tblCustomerid) REFERENCES tblCustomer(id)
);

CREATE TABLE tblAppointment (
  id INT(10) PRIMARY KEY AUTO_INCREMENT,
  appointmentTime DATETIME,
  note VARCHAR(255),
  tblCustomerid INT(10) NOT NULL,
  FOREIGN KEY (tblCustomerid) REFERENCES tblCustomer(id)
);

CREATE TABLE tblService (
  id INT(10) PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255),
  price FLOAT(10),
  description VARCHAR(255)
);

CREATE TABLE tblPart (
  id INT(10) PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255),
  price FLOAT(10),
  unit VARCHAR(255),
  stockQuantity INT(10),
  description VARCHAR(255)
);

CREATE TABLE tblRepair (
  id INT(10) PRIMARY KEY AUTO_INCREMENT,
  receiveDate DATE,
  status VARCHAR(255),
  tblCarid INT(10) NOT NULL,
  tblMemberid INT(10) NOT NULL,
  FOREIGN KEY (tblCarid) REFERENCES tblCar(id),
  FOREIGN KEY (tblMemberid) REFERENCES tblMember(id)
);

CREATE TABLE tblUsedService (
  id INT(10) PRIMARY KEY AUTO_INCREMENT,
  quantity INT(10),
  price FLOAT(10),
  tblRepairid INT(10) NOT NULL,
  tblServiceid INT(10) NOT NULL,
  tblTechnicianid INT(10),
  FOREIGN KEY (tblRepairid) REFERENCES tblRepair(id),
  FOREIGN KEY (tblServiceid) REFERENCES tblService(id),
  FOREIGN KEY (tblTechnicianid) REFERENCES tblTechnician(id)
);

CREATE TABLE tblUsedPart (
  id INT(10) PRIMARY KEY AUTO_INCREMENT,
  quantity INT(10),
  price FLOAT(10),
  tblRepairid INT(10) NOT NULL,
  tblPartid INT(10) NOT NULL,
  FOREIGN KEY (tblRepairid) REFERENCES tblRepair(id),
  FOREIGN KEY (tblPartid) REFERENCES tblPart(id)
);

CREATE TABLE tblBill (
  id INT(10) PRIMARY KEY AUTO_INCREMENT,
  paymentDate DATE,
  tblRepairid INT(10) NOT NULL UNIQUE,
  tblMemberid INT(10) NOT NULL,
  FOREIGN KEY (tblRepairid) REFERENCES tblRepair(id),
  FOREIGN KEY (tblMemberid) REFERENCES tblMember(id)
);

CREATE TABLE tblImportBill (
  id INT(10) PRIMARY KEY AUTO_INCREMENT,
  importDate DATE,
  tblSupplierid INT(10) NOT NULL,
  tblMemberid INT(10) NOT NULL,
  FOREIGN KEY (tblSupplierid) REFERENCES tblSupplier(id),
  FOREIGN KEY (tblMemberid) REFERENCES tblMember(id)
);

CREATE TABLE tblImportedPart (
  id INT(10) PRIMARY KEY AUTO_INCREMENT,
  quantity INT(10),
  price FLOAT(10),
  tblImportBillid INT(10) NOT NULL,
  tblPartid INT(10) NOT NULL,
  FOREIGN KEY (tblImportBillid) REFERENCES tblImportBill(id),
  FOREIGN KEY (tblPartid) REFERENCES tblPart(id)
);

-- =====================================================================
-- DỮ LIỆU MẪU
-- Các dòng đầu tiên của mỗi bảng giữ đúng dữ liệu trong kịch bản của báo cáo:
--   * tìm "dầu"        -> 2 dịch vụ + 2 phụ tùng
--   * tìm "Nguyễn Văn B" -> Nguyễn Văn B, Nguyễn Văn Bình
--   * hoá đơn của Nguyễn Văn B: 1.220.000 đ; tìm "má phanh" -> 2 phụ tùng
-- Vì vậy dữ liệu thêm vào KHÔNG có tên chứa "dầu", "má phanh", "Nguyễn Văn B".
-- Mật khẩu của mọi nhân viên: 123456
-- =====================================================================

-- Nhân viên (position: sale = bán hàng, manager = quản lí, warehouse = kho)
INSERT INTO tblMember(username, password, fullName, birthday, address, email, tel, position) VALUES
  ('nvc',  '123456', 'Nguyễn Văn C',  '1995-03-12', 'Hà Nội',   'nvc@garaman.vn',  '0901000001', 'sale'),
  ('nvd',  '123456', 'Hoàng Thị Dung', '1997-07-25', 'Hà Nội',   'nvd@garaman.vn',  '0901000002', 'sale'),
  ('ql01', '123456', 'Trần Quang Huy', '1988-11-02', 'Hà Nội',   'ql01@garaman.vn', '0901000003', 'manager'),
  ('kho01','123456', 'Phạm Văn Khải',  '1992-05-18', 'Bắc Ninh', 'kho01@garaman.vn','0901000004', 'warehouse');

-- Nhân viên kỹ thuật
INSERT INTO tblTechnician(fullName, tel, address, specialty) VALUES
  ('Trần Văn D',  '0912000001', 'Hà Nội',   'Động cơ'),
  ('Lê Văn E',    '0912000002', 'Hà Nội',   'Gầm, lái'),
  ('Vũ Văn Hùng', '0912000003', 'Hưng Yên', 'Điện, điều hoà'),
  ('Đỗ Văn Long', '0912000004', 'Hà Nội',   'Lốp, phanh'),
  ('Phan Văn Minh','0912000005','Hà Nam',   'Đồng, sơn');

-- Khách hàng
INSERT INTO tblCustomer(fullName, tel, address, email) VALUES
  ('Nguyễn Văn B',    '0912345678', 'Hà Nội',    'nvb@gmail.com'),
  ('Nguyễn Văn Bình', '0987654321', 'Hưng Yên',  'binhnv@gmail.com'),
  ('Trần Thị Hoa',    '0934111222', 'Hải Phòng', 'hoatt@gmail.com'),
  ('Lê Minh Tuấn',    '0945222333', 'Bắc Ninh',  'tuanlm@gmail.com'),
  ('Phạm Thu Trang',  '0956333444', 'Hà Nội',    'trangpt@gmail.com'),
  ('Đặng Quốc Việt',  '0967444555', 'Hà Nam',    'vietdq@gmail.com'),
  ('Bùi Thị Lan',     '0978555666', 'Nam Định',  'lanbt@gmail.com'),
  ('Ngô Đức Anh',     '0989666777', 'Hà Nội',    'anhnd@gmail.com');

-- Xe (khách 1 và khách 5 có 2 xe)
INSERT INTO tblCar(licensePlate, brand, model, tblCustomerid) VALUES
  ('29A-123.45', 'Toyota',     'Vios',     1),
  ('30F-678.90', 'Honda',      'City',     2),
  ('15A-234.56', 'Kia',        'Morning',  3),
  ('99A-345.67', 'Mazda',      '3',        4),
  ('30G-456.78', 'Hyundai',    'Accent',   5),
  ('30H-111.22', 'Toyota',     'Fortuner', 5),
  ('90A-567.89', 'Ford',       'Ranger',   6),
  ('18A-678.12', 'Mitsubishi', 'Xpander',  7),
  ('30K-789.23', 'VinFast',    'VF8',      8),
  ('29B-222.33', 'Toyota',     'Innova',   1);

-- Lịch hẹn
INSERT INTO tblAppointment(appointmentTime, note, tblCustomerid) VALUES
  ('2026-11-22 08:30:00', 'Bảo dưỡng định kỳ 10.000 km', 4),
  ('2026-11-22 14:00:00', 'Kiểm tra tiếng kêu khi phanh', 5),
  ('2026-11-23 09:00:00', 'Vệ sinh điều hoà', 8);

-- Dịch vụ
INSERT INTO tblService(name, price, description) VALUES
  ('Thay dầu động cơ',            150000, 'Thay dầu động cơ định kỳ'),
  ('Thay dầu hộp số',             250000, 'Thay dầu hộp số tự động'),
  ('Cân chỉnh thước lái',         300000, 'Cân chỉnh góc đặt bánh xe'),
  ('Rửa xe và hút bụi',           100000, 'Rửa ngoài, hút bụi nội thất'),
  ('Bảo dưỡng định kỳ 10.000 km', 800000, 'Kiểm tra tổng quát theo khuyến cáo của hãng'),
  ('Vệ sinh điều hoà',            450000, 'Vệ sinh giàn lạnh, thay khí gas nếu thiếu'),
  ('Kiểm tra và bảo dưỡng phanh', 200000, 'Vệ sinh, kiểm tra độ mòn hệ thống phanh'),
  ('Đảo lốp và cân bằng động',    200000, 'Đảo vị trí 4 lốp, cân bằng động bánh xe'),
  ('Sơn dặm vết xước',            600000, 'Sơn dặm một vị trí trầy xước nhỏ'),
  ('Kiểm tra hệ thống điện',      150000, 'Kiểm tra ắc quy, máy phát, đèn');

-- Phụ tùng
INSERT INTO tblPart(name, price, unit, stockQuantity, description) VALUES
  ('Dầu nhớt Castrol 4L',      650000, 'can',   20, 'Dầu động cơ tổng hợp, dùng cho xe du lịch'),
  ('Lọc dầu Toyota',           120000, 'cái',   30, 'Lọc dầu chính hãng Toyota'),
  ('Má phanh trước Toyota',    400000, 'bộ',    10, 'Má phanh trước chính hãng'),
  ('Má phanh sau Toyota',      350000, 'bộ',    10, 'Má phanh sau chính hãng'),
  ('Lọc gió động cơ Toyota',   180000, 'cái',   25, 'Lọc gió động cơ chính hãng'),
  ('Lọc gió điều hoà',         150000, 'cái',   25, 'Lọc gió cabin than hoạt tính'),
  ('Ắc quy GS 60Ah',          1800000, 'bình',   8, 'Ắc quy khô, bảo hành 12 tháng'),
  ('Bugi NGK Iridium',         250000, 'cái',   40, 'Bugi đầu Iridium bền 60.000 km'),
  ('Gạt mưa Bosch 24 inch',    220000, 'cái',   15, 'Lưỡi gạt mưa không xương'),
  ('Lốp Michelin 185/60R15',  1900000, 'chiếc', 16, 'Lốp xe du lịch, êm, tiết kiệm nhiên liệu'),
  ('Nước làm mát Toyota 1L',   120000, 'chai',  30, 'Nước làm mát pha sẵn màu hồng'),
  ('Bóng đèn pha Philips H4',  160000, 'cái',   20, 'Bóng đèn pha halogen tăng sáng');

-- Nhà cung cấp
INSERT INTO tblSupplier(name, address, tel, email, description) VALUES
  ('Phụ tùng Toyota Việt Nam', 'Mê Linh, Hà Nội',     '02438001001', 'phutung@toyota.vn', 'Phụ tùng chính hãng Toyota'),
  ('Castrol BP Petco',         'Quận 1, TP. Hồ Chí Minh', '02838002002', 'sales@castrol.vn',  'Dầu nhớt, chất bôi trơn'),
  ('Michelin Việt Nam',        'Quận 7, TP. Hồ Chí Minh', '02838003003', 'contact@michelin.vn','Lốp xe các loại');

-- Hoá đơn nhập (do NV kho id 4 lập)
INSERT INTO tblImportBill(importDate, tblSupplierid, tblMemberid) VALUES
  ('2026-10-01', 1, 4),
  ('2026-10-15', 2, 4),
  ('2026-11-01', 3, 4);
INSERT INTO tblImportedPart(quantity, price, tblImportBillid, tblPartid) VALUES
  (20,  90000, 1, 2), (10, 300000, 1, 3), (10, 260000, 1, 4), (20, 130000, 1, 5),
  (25, 520000, 2, 1),
  (16, 1550000, 3, 10);

-- Lượt sửa chữa
--   1-4 : chưa thanh toán (khách 1, 2, 3, 6)
--   5-10: đã thanh toán, có hoá đơn (khách 4, 5, 7, 8 và xe thứ 2 của khách 1)
INSERT INTO tblRepair(receiveDate, status, tblCarid, tblMemberid) VALUES
  ('2026-11-15', 'unpaid', 1,  1),
  ('2026-11-16', 'unpaid', 2,  1),
  ('2026-11-17', 'unpaid', 3,  2),
  ('2026-11-18', 'unpaid', 7,  1),
  ('2026-10-05', 'paid',   4,  1),
  ('2026-10-12', 'paid',   5,  2),
  ('2026-10-20', 'paid',   6,  1),
  ('2026-11-02', 'paid',   8,  2),
  ('2026-11-08', 'paid',   9,  1),
  ('2026-11-10', 'paid',   10, 2);

-- Dịch vụ đã dùng (price = giá tại thời điểm sử dụng)
INSERT INTO tblUsedService(quantity, price, tblRepairid, tblServiceid, tblTechnicianid) VALUES
  (1, 150000, 1, 1, 1), (1, 300000, 1, 3, 2),                         -- lượt 1: kịch bản báo cáo
  (1, 800000, 2, 5, 1), (1, 100000, 2, 4, 3),
  (1, 450000, 3, 6, 3),
  (1, 200000, 4, 8, 4), (1, 300000, 4, 3, 2),
  (1, 140000, 5, 1, 1),                                               -- giá cũ 140.000
  (1, 800000, 6, 5, 1), (1, 150000, 6, 10, 3),
  (1, 600000, 7, 9, 5),
  (1, 250000, 8, 2, 1), (1, 150000, 8, 1, 1),
  (1, 150000, 9, 10, 3), (1, 100000, 9, 4, 5),
  (1, 200000, 10, 7, 4);

-- Phụ tùng đã dùng
INSERT INTO tblUsedPart(quantity, price, tblRepairid, tblPartid) VALUES
  (1, 650000, 1, 1), (1, 120000, 1, 2),                               -- lượt 1: kịch bản báo cáo
  (1, 180000, 2, 5), (2, 120000, 2, 11),
  (1, 150000, 3, 6),
  (2, 1900000, 4, 10),
  (1, 620000, 5, 1), (1, 120000, 5, 2),                               -- giá cũ 620.000
  (4, 250000, 6, 8),
  (1, 650000, 8, 1),
  (1, 1800000, 9, 7),
  (2, 160000, 10, 12);

-- Hoá đơn của các lượt đã thanh toán
INSERT INTO tblBill(paymentDate, tblRepairid, tblMemberid) VALUES
  ('2026-10-05', 5,  1),
  ('2026-10-13', 6,  2),
  ('2026-10-21', 7,  1),
  ('2026-11-03', 8,  2),
  ('2026-11-08', 9,  1),
  ('2026-11-11', 10, 2);
