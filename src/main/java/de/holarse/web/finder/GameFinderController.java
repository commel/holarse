package de.holarse.web.finder;

import de.holarse.backend.db.Article;
import de.holarse.backend.db.TagGroupType;
import de.holarse.backend.db.repositories.ArticleRepository;
import de.holarse.backend.db.repositories.TagGroupRepository;
import de.holarse.backend.db.repositories.TagRepository;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.StringJoiner;
import java.util.stream.Collectors;
import javax.transaction.Transactional;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.Hibernate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

@Controller
@RequestMapping("/finder/")
public class GameFinderController {

    Logger logger = LoggerFactory.getLogger(GameFinderController.class);
    
    @Autowired TagGroupRepository tagGroupRepository;
    @Autowired TagRepository tagRepository;
    
    @Autowired ArticleRepository articleRepository;
    
    @Transactional
    @GetMapping
    public ModelAndView index(@RequestParam(value = "tags", required = false) final List<String> tags, 
                        @RequestParam(value = "tag",  required = false) final String newTag, 
                        final Model map) {
        map.addAttribute("licenses", tagRepository.findByTagGroup(TagGroupType.LICENSE));
        map.addAttribute("genres", tagRepository.findByTagGroup(TagGroupType.GENRE));
        map.addAttribute("freeTags", tagRepository.findFreeTags());
        
        // Bestehende Tags einfügen
        final Set<String> chosenTags = new HashSet<>();
        if (tags != null) {
            chosenTags.addAll(tags);
        }
        
        // Neuen Tag einfügen oder entfernen falls bereits vorhanden
        boolean redirectAfterNewTag = false;        
        if (StringUtils.isNotBlank(newTag)) {
            if (chosenTags.contains(newTag)) {
                chosenTags.remove(newTag);
            } else {
                chosenTags.add(newTag);
            }
            redirectAfterNewTag = true;
        }
        
        // Wenn Tags komplett leer sind, immer Top-Titel anzeigen
        if (chosenTags.isEmpty()) {
            chosenTags.add("Top-Titel");
        }
        
        logger.debug("CHOSEN TAGS: " + chosenTags);        
        
        final String taglist = chosenTags.stream().collect(Collectors.joining(","));
        
        // Neues Tag hinzufügen und Seite neuladen
        if (redirectAfterNewTag) {
            return new ModelAndView(new RedirectView("/finder/?tags=" + taglist, false, false, false));
        }
        

        
        // Ergebnisse anzeigen
        final List<Article> articles = articleRepository.findByTags(chosenTags);
        articles.forEach(a -> Hibernate.initialize(a.getTags()));
        map.addAttribute("nodes", articles);
        map.addAttribute("tags", chosenTags.stream().map(ct -> tagRepository.findByName(ct)).filter(Optional::isPresent).map(Optional::get).collect(Collectors.toList()));
        map.addAttribute("taglist", taglist);
        
        return new ModelAndView("finder/index");
    }
    
}
