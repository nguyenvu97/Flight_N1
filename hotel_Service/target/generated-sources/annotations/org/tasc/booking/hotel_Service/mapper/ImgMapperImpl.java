package org.tasc.booking.hotel_Service.mapper;

import java.util.ArrayList;
import java.util.List;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;
import org.tasc.booking.hotel_Service.dto.ImageDto;
import org.tasc.booking.hotel_Service.entity.Image;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2024-11-12T10:30:53+0700",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 20.0.1 (Oracle Corporation)"
)
@Component
public class ImgMapperImpl implements ImgMapper {

    @Override
    public Image toDto(ImageDto imageDto) {
        if ( imageDto == null ) {
            return null;
        }

        Image image = new Image();

        image.setId( imageDto.getId() );
        image.setImg( imageDto.getImg() );
        image.setPathImg( imageDto.getPathImg() );

        return image;
    }

    @Override
    public ImageDto toEntity(Image image) {
        if ( image == null ) {
            return null;
        }

        ImageDto imageDto = new ImageDto();

        imageDto.setId( image.getId() );
        imageDto.setImg( image.getImg() );
        imageDto.setPathImg( image.getPathImg() );

        return imageDto;
    }

    @Override
    public List<Image> toListEntity(List<ImageDto> d) {
        if ( d == null ) {
            return null;
        }

        List<Image> list = new ArrayList<Image>( d.size() );
        for ( ImageDto imageDto : d ) {
            list.add( toDto( imageDto ) );
        }

        return list;
    }

    @Override
    public List<ImageDto> toListDto(List<Image> e) {
        if ( e == null ) {
            return null;
        }

        List<ImageDto> list = new ArrayList<ImageDto>( e.size() );
        for ( Image image : e ) {
            list.add( toEntity( image ) );
        }

        return list;
    }
}
