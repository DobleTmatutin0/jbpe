package ar.edu.unpsjb.jbpe.business.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ar.edu.unpsjb.jbpe.business.repository.EjemplarRepository;
import ar.edu.unpsjb.jbpe.business.repository.EventoRepository;
import ar.edu.unpsjb.jbpe.business.repository.PersonaRepository;
import ar.edu.unpsjb.jbpe.model.dto.EventoDTO;
import ar.edu.unpsjb.jbpe.model.entity.Evento;

@Service

public class EventoService {
    private final EventoRepository eventoRepository;
    private final PersonaRepository personaRepository;
    private final EjemplarRepository ejemplarRepository;

    public EventoService(
        EventoRepository eventoRepository,
        PersonaRepository personaRepository,
        EjemplarRepository ejemplarRepository
    ) {
        this.eventoRepository = eventoRepository;
        this.personaRepository = personaRepository;
        this.ejemplarRepository = ejemplarRepository;
    }

    public List<EventoDTO> findAll() {
        return eventoRepository.findAllDTO();
    }

    @Transactional
    public Evento save(EventoDTO aEventoDTO) {
        Evento eventoToSave = new Evento();

        eventoToSave.setTipoDeEvento(aEventoDTO.getTipoDeEvento());
        eventoToSave.setFecha(aEventoDTO.getFecha());
        eventoToSave.setRealizadoPor(personaRepository.getReferenceById(aEventoDTO.getRealizadoPor().getId()));
        eventoToSave.setEjemplar(ejemplarRepository.getReferenceById(ejemplarRepository.findDTOById(aEventoDTO.getAdquisicionId()).getId()));
        eventoToSave.setObservaciones(aEventoDTO.getObservaciones());

        return eventoRepository.save(eventoToSave);
    }

}
