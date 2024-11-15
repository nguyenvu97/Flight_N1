package org.tasc.booking.ticket_Service.entity.Enum;

public enum FlightStatus {
    Scheduled,      // Đã lên lịch
    OnTime,         // Đúng giờ
    Delayed,        // Chậm trễ
    Cancelled,      // Đã hủy
    Completed,      // Hoàn tất
    InProgress,     // Đang tiến hành
    Diverted,       // Chuyển hướng
    Unknown         // Không rõ
}
