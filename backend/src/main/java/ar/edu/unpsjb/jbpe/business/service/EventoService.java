package ar.edu.unpsjb.jbpe.business.service;

import java.util.List;

import org.springframework.stereotype.Service;

import ar.edu.unpsjb.jbpe.business.repository.EventoRepository;
import ar.edu.unpsjb.jbpe.model.dto.EventoDTO;
import ar.edu.unpsjb.jbpe.model.entity.Evento;

@Service

public class EventoService {
    private final EventoRepository eventoRepository;

    public EventoService(EventoRepository eventoRepository) {
        this.eventoRepository = eventoRepository;
    }

    public List<EventoDTO> findAll() {
        return eventoRepository.findAllDTO();
    }

    public Evento save(EventoDTO aEventoDTO) {
        Evento eventoToSave = new Evento()

        eventoToSave.set
        eventoToSave.set
        eventoToSave.set
        eventoToSave.set

        return eventoRepository.save(eventoToSave);
    }

}
