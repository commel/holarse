package de.holarse.backend.db;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.ConstraintMode;
import javax.persistence.FetchType;
import javax.persistence.ForeignKey;
import javax.persistence.JoinColumn;
import javax.persistence.MappedSuperclass;
import javax.persistence.OneToMany;

@MappedSuperclass
public abstract class CommentableNode extends RevisionableNode {
    
    /**
     * Kann kommentiert werden
     */
    @Column(nullable = false, columnDefinition = "boolean default true")    
    private Boolean commentable;    
    
    @OneToMany(fetch = FetchType.LAZY)
    @JoinColumn(name = "node_id", foreignKey = @ForeignKey(name="none", value = ConstraintMode.NO_CONSTRAINT))
    private List<Comment> comments = new ArrayList<>();

    public List<Comment> getComments() {
        return comments;
    }

    public void setComments(List<Comment> comments) {
        this.comments = comments;
    }

    @Override
    public Boolean getCommentable() {
        return commentable;
    }

    @Override
    public void setCommentable(Boolean commentable) {
        this.commentable = commentable;
    }
   
}
