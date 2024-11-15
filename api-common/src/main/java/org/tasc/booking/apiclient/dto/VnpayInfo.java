package org.tasc.booking.apiclient.dto;


import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "vnPayInfo")
@Builder
public class VnpayInfo {
     @Id
    public String id;
    private long amount;
    private String BankCode;
    private String OrderInfo;
    private String responseCode;
    private String vnp_TxnRef;
    private String vnp_TransactionNo;
}
