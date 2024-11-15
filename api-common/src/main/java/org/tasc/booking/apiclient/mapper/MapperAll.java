package org.tasc.booking.apiclient.mapper;

import java.util.List;

public interface MapperAll  <E,D>{
    E toDto(D d);
    D toEntity(E e);
    List<E> toListEntity(List<D> d);
    List<D> toListDto(List<E> e);
}
