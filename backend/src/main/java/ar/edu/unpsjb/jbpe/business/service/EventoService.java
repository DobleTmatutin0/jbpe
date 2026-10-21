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
import ar.edu.unpsjb.jbpe.business.repository.NombreEspecieRepository;
import ar.edu.unpsjb.jbpe.business.repository.PersonaRepository;
import ar.edu.unpsjb.jbpe.model.dto.evento.EventoCheckeoAnualDTO;
import ar.edu.unpsjb.jbpe.model.dto.evento.EventoDTO;
import ar.edu.unpsjb.jbpe.model.dto.evento.EventoDesaccesionDTO;
import ar.edu.unpsjb.jbpe.model.dto.evento.EventoDeterminarTaxonDTO;
import ar.edu.unpsjb.jbpe.model.dto.evento.EventoTransplanteDTO;
import ar.edu.unpsjb.jbpe.model.dto.evento.create.EventoCreateDTO;
import ar.edu.unpsjb.jbpe.model.dto.evento.create.EventoDeterminarTaxonCreateDTO;
import ar.edu.unpsjb.jbpe.model.dto.evento.create.EventoIngresoCreateDTO;
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
    private final NombreEspecieRepository nombreEspecieRepository;

    public EventoService(
        EventoRepository eventoRepository,
        EventoIngresoRepository eventoIngresoRepository,
        EventoDeterminarTaxonRepository eventoDeterminarTaxonRepository,
        EventoTrasplanteRepository eventoTrasplanteRepository,
        EventoCheckeoAnualRepository eventoCheckeoAnualRepository,
        EventoDesaccesionRepository eventoDesaccesionRepository,
        PersonaRepository personaRepository,
        EjemplarRepository ejemplarRepository,
        NombreEspecieRepository nombreEspecieRepository
    ) {
        this.eventoRepository = eventoRepository;
        this.eventoIngresoRepository = eventoIngresoRepository;
        this.eventoDeterminarTaxonRepository = eventoDeterminarTaxonRepository;
        this.eventoTrasplanteRepository = eventoTrasplanteRepository;
        this.eventoCheckeoAnualRepository = eventoCheckeoAnualRepository;
        this.eventoDesaccesionRepository = eventoDesaccesionRepository;
        this.personaRepository = personaRepository;
        this.ejemplarRepository = ejemplarRepository;
        this.nombreEspecieRepository = nombreEspecieRepository;
    }

    public List<EventoDTO> findAll() {
        return eventoRepository.findAllDTO();
    }

    private Evento saveEventoBase(EventoCreateDTO aEventoCreateDTO) {
        Evento eventoToSave = new Evento();

        eventoToSave.setTipoDeEvento(aEventoCreateDTO.getTipoDeEvento());
        eventoToSave.setFecha(aEventoCreateDTO.getFecha());
        eventoToSave.setRealizadoPor(personaRepository.getReferenceById(aEventoCreateDTO.getRealizadoPorId()));
        eventoToSave.setEjemplar(ejemplarRepository.getReferenceById(aEventoCreateDTO.getEjemplarId()));
        eventoToSave.setObservaciones(aEventoCreateDTO.getObservaciones());

        return eventoRepository.save(eventoToSave);
    }

    @Transactional
    public Integer saveEventoIngreso(EventoIngresoCreateDTO aEventoIngresoCreateDTO) {
        Evento eventoBase = this.saveEventoBase(aEventoIngresoCreateDTO);

        EventoIngreso newEventoIngreso = new EventoIngreso();

        newEventoIngreso.setEvento(eventoBase);
        if (aEventoIngresoCreateDTO.getDonadoPorId() != null) {
            newEventoIngreso.setDonadoPor(
                personaRepository.getReferenceById(aEventoIngresoCreateDTO.getDonadoPorId()));
        }
        newEventoIngreso.setFechaDeDonacion(aEventoIngresoCreateDTO.getFechaDeDonacion());

        EventoIngreso savedEventoIngreso = eventoIngresoRepository.save(newEventoIngreso);
        return savedEventoIngreso.getId();
    }

    @Transactional
    public Integer saveEventoDeterminarTaxon(EventoDeterminarTaxonCreateDTO aEventoDeterminarTaxonCreateDTO) {
        Evento eventoBase = this.saveEventoBase(aEventoDeterminarTaxonCreateDTO);

        EventoDeterminarTaxon eventoDeterminarTaxonToSave = new EventoDeterminarTaxon();

        eventoDeterminarTaxonToSave.setEvento(eventoBase);
        if (aEventoDeterminarTaxonCreateDTO.getTaxonViejo() != null) {
            eventoDeterminarTaxonToSave.setTaxonViejo(
                nombreEspecieRepository.getReferenceById(aEventoDeterminarTaxonCreateDTO.getTaxonViejo())
            );
        }
        eventoDeterminarTaxonToSave.setTaxonNuevo(
            nombreEspecieRepository.getReferenceById(aEventoDeterminarTaxonCreateDTO.getTaxonNuevo())
        );

        EventoDeterminarTaxon savedEventoDeterminarTaxon = eventoDeterminarTaxonRepository.save(eventoDeterminarTaxonToSave);
        return savedEventoDeterminarTaxon.getId();
    }

    @Transactional
    public EventoTrasplante saveEventoTrasplante(EventoTransplanteDTO aEventoTrasplanteDTO) {
        EventoTrasplante eventoTrasplanteToSave = new EventoTrasplante();

        eventoTrasplanteToSave.setEvento(aEventoTrasplanteDTO.getEvento());
        eventoTrasplanteToSave.setSectorInicial(aEventoTrasplanteDTO.getSectorInicial());
        eventoTrasplanteToSave.setTrasplantadoPor(personaRepository.getReferenceById(aEventoTrasplanteDTO.getTrasplantadoPor().getId()));
        eventoTrasplanteToSave.setComoFuePlantadoEnPredio(aEventoTrasplanteDTO.getComoFuePlantadoEnPredio());

        return eventoTrasplanteRepository.save(eventoTrasplanteToSave);
    }

    @Transactional
    public EventoCheckeoAnual saveEventoCheckeoAnual(EventoCheckeoAnualDTO aEventoCheckeoAnualDTO) {
        EventoCheckeoAnual eventoCheckeoAnualToSave = new EventoCheckeoAnual();

        eventoCheckeoAnualToSave.setEvento(aEventoCheckeoAnualDTO.getEvento());
        eventoCheckeoAnualToSave.setAlturaEnCm(aEventoCheckeoAnualDTO.getAlturaEnCm());
        eventoCheckeoAnualToSave.setDiametroEnCm(aEventoCheckeoAnualDTO.getDiametroEnCm());
        eventoCheckeoAnualToSave.setEstadoDeSalud(aEventoCheckeoAnualDTO.getEstadoDeSalud());
        eventoCheckeoAnualToSave.setFlorecio(aEventoCheckeoAnualDTO.isFlorecio());
        eventoCheckeoAnualToSave.setFructifico(aEventoCheckeoAnualDTO.isFlorecio());

        return eventoCheckeoAnualRepository.save(eventoCheckeoAnualToSave);
    }

    @Transactional
    public EventoDesaccesion saveEventoDesaccesion(EventoDesaccesionDTO aEventoDesaccesionDTO) {
        EventoDesaccesion eventoDesaccesionToSave = new EventoDesaccesion();

        eventoDesaccesionToSave.setEvento(aEventoDesaccesionDTO.getEvento());
        eventoDesaccesionToSave.setMotivo(aEventoDesaccesionDTO.getMotivo());

        return eventoDesaccesionRepository.save(eventoDesaccesionToSave);
    }
}
