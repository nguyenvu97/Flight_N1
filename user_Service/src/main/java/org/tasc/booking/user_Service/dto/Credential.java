package org.tasc.booking.user_Service.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class Credential {
    @JsonProperty("temporary")
    private boolean temporary;

    @JsonProperty("type")
    private String type;

    @JsonProperty("value")
    private String value;
}
