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
import ar.edu.unpsjb.jbpe.business.repository.SectorRepository;
import ar.edu.unpsjb.jbpe.model.dto.evento.EventoDTO;
import ar.edu.unpsjb.jbpe.model.dto.evento.create.EventoCheckeoAnualCreateDTO;
import ar.edu.unpsjb.jbpe.model.dto.evento.create.EventoCreateDTO;
import ar.edu.unpsjb.jbpe.model.dto.evento.create.EventoDesaccesionCreateDTO;
import ar.edu.unpsjb.jbpe.model.dto.evento.create.EventoDeterminarTaxonCreateDTO;
import ar.edu.unpsjb.jbpe.model.dto.evento.create.EventoIngresoCreateDTO;
import ar.edu.unpsjb.jbpe.model.dto.evento.create.EventoTrasplanteCreateDTO;
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
    private final SectorRepository sectorRepository;

    public EventoService(
        EventoRepository eventoRepository,
        EventoIngresoRepository eventoIngresoRepository,
        EventoDeterminarTaxonRepository eventoDeterminarTaxonRepository,
        EventoTrasplanteRepository eventoTrasplanteRepository,
        EventoCheckeoAnualRepository eventoCheckeoAnualRepository,
        EventoDesaccesionRepository eventoDesaccesionRepository,
        PersonaRepository personaRepository,
        EjemplarRepository ejemplarRepository,
        NombreEspecieRepository nombreEspecieRepository,
        SectorRepository sectorRepository
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
        this.sectorRepository = sectorRepository;
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
    public Long saveEventoAccecion(EventoCreateDTO aEventoAccecionCreateDTO) {
        Evento eventoBase = this.saveEventoBase(aEventoAccecionCreateDTO);

        return eventoBase.getId();
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
    public Integer saveEventoTrasplante(EventoTrasplanteCreateDTO aEventoTrasplanteCreateDTO) {
        Evento eventoBase = this.saveEventoBase(aEventoTrasplanteCreateDTO);

        EventoTrasplante eventoTrasplanteToSave = new EventoTrasplante();

        eventoTrasplanteToSave.setEvento(eventoBase);

        eventoTrasplanteToSave.setSectorInicial(sectorRepository.getReferenceById(aEventoTrasplanteCreateDTO.getSectorInicialId()));
        eventoTrasplanteToSave.setTrasplantadoPor(personaRepository.getReferenceById(aEventoTrasplanteCreateDTO.getRealizadoPorId()));
        if (aEventoTrasplanteCreateDTO.getComoFuePlantadoEnPredio() != null) {
            eventoTrasplanteToSave.setComoFuePlantadoEnPredio(aEventoTrasplanteCreateDTO.getComoFuePlantadoEnPredio());
        }

        EventoTrasplante savedEventoTrasplante = eventoTrasplanteRepository.save(eventoTrasplanteToSave);
        return savedEventoTrasplante.getId();
    }

    @Transactional
    public Integer saveEventoCheckeoAnual(EventoCheckeoAnualCreateDTO aEventoCheckeoAnualCreateDTO) {
        Evento eventoBase = this.saveEventoBase(aEventoCheckeoAnualCreateDTO);

        EventoCheckeoAnual eventoCheckeoAnualToSave = new EventoCheckeoAnual();

        eventoCheckeoAnualToSave.setEvento(eventoBase);
        if (aEventoCheckeoAnualCreateDTO.getAlturaEnCm() != null) {
            eventoCheckeoAnualToSave.setAlturaEnCm(aEventoCheckeoAnualCreateDTO.getAlturaEnCm());
        }
        if (aEventoCheckeoAnualCreateDTO.getDiametroEnCm() != null) {
            eventoCheckeoAnualToSave.setDiametroEnCm(aEventoCheckeoAnualCreateDTO.getDiametroEnCm());
        }
        eventoCheckeoAnualToSave.setEstadoDeSalud(aEventoCheckeoAnualCreateDTO.getEstadoDeSalud());
        eventoCheckeoAnualToSave.setFlorecio(aEventoCheckeoAnualCreateDTO.isFlorecio());
        eventoCheckeoAnualToSave.setFructifico(aEventoCheckeoAnualCreateDTO.isFructifico());

        EventoCheckeoAnual savedEventoCheckeoAnual = eventoCheckeoAnualRepository.save(eventoCheckeoAnualToSave);
        return savedEventoCheckeoAnual.getId();
    }

    @Transactional
    public Integer saveEventoDesaccesion(EventoDesaccesionCreateDTO aEventoDesaccesionCreateDTO) {
        Evento eventoBase = this.saveEventoBase(aEventoDesaccesionCreateDTO);

        EventoDesaccesion eventoDesaccesionToSave = new EventoDesaccesion();

        eventoDesaccesionToSave.setEvento(eventoBase);
        eventoDesaccesionToSave.setMotivo(aEventoDesaccesionCreateDTO.getMotivo());

        EventoDesaccesion savedEventoDesaccesion = eventoDesaccesionRepository.save(eventoDesaccesionToSave);
        return savedEventoDesaccesion.getId();
    }
}
