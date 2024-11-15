package org.tasc.booking.apiclient.ex;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum ExceptionMessagesEnum {

    CLIENT_NOT_FOUND("Client not found"),

    EMAIL_BAD_FORMAT("Email has bad format"),

    CLIENT_ALREADY_EXISTS("Client already exists"),

    ASSETS_ALREADY_EXISTS("Assets already exists");

    private final String description;

}
