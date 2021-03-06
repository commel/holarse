package de.holarse.renderer.html;

import de.holarse.renderer.Mode;

public class ParagraphMode implements Mode {

    private final StringBuilder buffer = new StringBuilder(1024);
    private int newlines = 0;
    private boolean complete = false;

    @Override
    public void handle(char ch) {
        if ('\n' == ch) {
            newlines++;
        } else {
            newlines = 0;
        }
        
        if (newlines >= 2) {
            complete = true;
            return;
        }
        
        buffer.append(ch);
    }

    @Override
    public StringBuilder render() {
        final StringBuilder result = new StringBuilder();
        result.append("<p>").append(buffer).append("</p>");
        return result;
    }

    @Override
    public void clear() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public boolean isComplete() {
        return complete;
    }
    
}
