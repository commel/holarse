package de.holarse.factories;

import java.util.Optional;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import de.holarse.backend.db.ApiUser;
import de.holarse.backend.db.Drueckblick;
import de.holarse.backend.db.DrueckblickEntry;
import de.holarse.backend.db.Role;
import de.holarse.backend.db.User;
import de.holarse.backend.db.UserStat;
import de.holarse.backend.views.admin.ApiUserAdminView;
import de.holarse.backend.views.admin.DrueckblickAdminView;
import de.holarse.backend.views.admin.DrueckblickEntryAdminView;
import de.holarse.backend.views.admin.UserAdminView;
import de.holarse.services.DateUtils;

@Component
public class AdminViewFactory {

    Logger logger = LoggerFactory.getLogger(AdminViewFactory.class);

    public DrueckblickEntryAdminView fromDrueckblickEntry(final DrueckblickEntry entity) {
        DrueckblickEntryAdminView view = new DrueckblickEntryAdminView();

        view.setId(entity.getId());
        view.setBearer(entity.getBearer());
        view.setCategory(entity.getCategory());
        if (entity.getDrueckblick() != null) {
            view.setDrueckblick(fromDrueckblick(entity.getDrueckblick()));
        }
        view.setLink(entity.getLink());
        view.setMessage(entity.getMessage());
        view.setCreated(DateUtils.formatShort(entity.getCreated()));
        view.setCreatedAgo(DateUtils.formatAgo(entity.getCreated()));
        view.setDeleted(entity.isDeleted());

        return view;
    }

    public DrueckblickAdminView fromDrueckblick(final Drueckblick entity) {
        DrueckblickAdminView view = new DrueckblickAdminView();

        view.setId(entity.getId());
        view.setBegin(DateUtils.formatDate(entity.getCoverageBegin()));
        view.setEnd(DateUtils.formatDate(entity.getCoverageEnd()));
        view.setName(entity.getName());
        view.setTitle(entity.getTitle());

        return view;
    }

    public ApiUserAdminView fromApiUser(final ApiUser entity) {
        ApiUserAdminView view = new ApiUserAdminView();

        view.setId(entity.getId());
        view.setLogin(entity.getLogin());
        view.setRolename(entity.getRoleName());
        view.setToken(entity.getToken());
        view.setCreated(DateUtils.formatDate(entity.getCreated()));
        view.setUpdated(DateUtils.formatDate(entity.getUpdated()));
        view.setActive(entity.isActive());

        return view;
    }

    public UserAdminView fromUser(final User entity) {
        UserAdminView view = new UserAdminView();
        view.setId(entity.getId());
        view.setLogin(entity.getLogin());
        view.setEmail(entity.getEmail());
        view.getRoles().addAll(entity.getRoles().stream().map(Role::getCode).collect(Collectors.toList()));
        view.setCreated(DateUtils.formatDate(entity.getCreated()));
        view.setUpdated(DateUtils.formatDate(entity.getUpdated()));
        view.setLastLogin(DateUtils.formatDate(Optional.ofNullable(entity.getUserStat()).map(UserStat::getLastLogin).orElse(null)));

        view.setVerified(entity.isVerified());
        view.setLocked(entity.isLocked());

        return view;
    }

}