package ar.edu.unpsjb.jbpe.business.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ar.edu.unpsjb.jbpe.business.repository.EjemplarRepository;
import ar.edu.unpsjb.jbpe.business.repository.EventoCheckeoAnualRepository;
import ar.edu.unpsjb.jbpe.business.repository.EventoDesaccesionRepository;
import ar.edu.unpsjb.jbpe.business.repository.EventoDeterminarTaxonRepository;
import ar.edu.unpsjb.jbpe.business.repository.EventoIngresoRepository;
import ar.edu.unpsjb.jbpe.business.repository.EventoRepository;
import ar.edu.unpsjb.jbpe.business.repository.EventoTrasplanteRepository;
import ar.edu.unpsjb.jbpe.business.repository.PersonaRepository;
import ar.edu.unpsjb.jbpe.model.dto.evento.EventoDTO;
import ar.edu.unpsjb.jbpe.model.entity.Evento;
import ar.edu.unpsjb.jbpe.model.entity.EventoCheckeoAnual;
import ar.edu.unpsjb.jbpe.model.entity.EventoDesaccesion;
import ar.edu.unpsjb.jbpe.model.entity.EventoDeterminarTaxon;
import ar.edu.unpsjb.jbpe.model.entity.EventoIngreso;
import ar.edu.unpsjb.jbpe.model.entity.EventoTrasplante;

@Service

public class EventoService {
    private final EventoRepository eventoRepository;
    private final EventoIngresoRepository eventoIngresoRepository;
    private final EventoDeterminarTaxonRepository eventoDeterminarTaxonRepository;
    private final EventoTrasplanteRepository eventoTrasplanteRepository;
    private final EventoCheckeoAnualRepository eventoCheckeoAnualRepository;
    private final EventoDesaccesionRepository eventoDesaccesionRepository;
    private final PersonaRepository personaRepository;
    private final EjemplarRepository ejemplarRepository;

    public EventoService(
        EventoRepository eventoRepository,
        EventoIngresoRepository eventoIngresoRepository,
        EventoDeterminarTaxonRepository eventoDeterminarTaxonRepository,
        EventoTrasplanteRepository eventoTrasplanteRepository,
        EventoCheckeoAnualRepository eventoCheckeoAnualRepository,
        EventoDesaccesionRepository eventoDesaccesionRepository,
        PersonaRepository personaRepository,
        EjemplarRepository ejemplarRepository
    ) {
        this.eventoRepository = eventoRepository;
        this.eventoIngresoRepository = eventoIngresoRepository;
        this.eventoDeterminarTaxonRepository = eventoDeterminarTaxonRepository;
        this.eventoTrasplanteRepository = eventoTrasplanteRepository;
        this.eventoCheckeoAnualRepository = eventoCheckeoAnualRepository;
        this.eventoDesaccesionRepository = eventoDesaccesionRepository;
        this.personaRepository = personaRepository;
        this.ejemplarRepository = ejemplarRepository;
    }

    public List<EventoDTO> findAll() {
        return eventoRepository.findAllDTO();
    }

    @Transactional
    public Evento saveEventoBase(EventoDTO aEventoDTO) {
        Evento eventoToSave = new Evento();

        eventoToSave.setTipoDeEvento(aEventoDTO.getTipoDeEvento());
        eventoToSave.setFecha(aEventoDTO.getFecha());
        eventoToSave.setRealizadoPor(personaRepository.getReferenceById(aEventoDTO.getRealizadoPor().getId()));
        eventoToSave.setEjemplar(ejemplarRepository.getReferenceById(ejemplarRepository.findDTOById(aEventoDTO.getAdquisicionId()).getId()));
        eventoToSave.setObservaciones(aEventoDTO.getObservaciones());

        return eventoRepository.save(eventoToSave);
    }

    @Transactional
    public EventoIngreso saveEventoIngreso() {

        return eventoIngresoRepository.save(entity);
    }

    @Transactional
    public EventoDeterminarTaxon saveEventoDeterminarTaxon() {

        return eventoDeterminarTaxonRepository.save();
    }

    @Transactional
    public EventoTrasplante saveEventoTrasplante() {

        return eventoTrasplanteRepository.save(entity);
    }

    @Transactional
    public EventoCheckeoAnual saveEventoCheckeoAnual() {

        return eventoCheckeoAnualRepository.save(entity);
    }

    @Transactional
    public EventoDesaccesion saveEventoDesaccesion() {

        return eventoDesaccesionRepository.save(entity);
    }
}
