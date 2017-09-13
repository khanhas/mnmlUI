function replacetext()
  scale = tonumber(SKIN:GetVariable('Scale'))
  text = SKIN:GetMeasure('MeasureHour'):GetStringValue()
  font = SELF:GetOption('FontFace')
  fontsize = SKIN:ParseFormula('('..SKIN:GetMeter('Minute'):GetOption('FontSize')..')')
  realFontSize = math.ceil(fontsize*100/70)
  X = 220*scale/2
  Y = 160*scale + 120*scale/2 + fontsize/2
  file = io.open(SKIN:MakePathAbsolute(SELF:GetOption("SVGfile")), "w")
  template={
    "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>",
    "<svg",
    "xmlns:dc=\"http://purl.org/dc/elements/1.1/\"",
    "xmlns:cc=\"http://creativecommons.org/ns#\"",
    "xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"",
    "xmlns:svg=\"http://www.w3.org/2000/svg\"",
    "xmlns=\"http://www.w3.org/2000/svg\"",
    "version=\"1.1\"",
    "width=\"440\"",
    "height=\"240\"",
    "id=\"svg2\">",
    "<defs",
    "id=\"defs4\" />",
    "<metadata",
    "id=\"metadata7\">",
    "<rdf:RDF>",
    "<cc:Work",
    "rdf:about=\"\">",
    "<dc:format>image/svg+xml</dc:format>",
    "<dc:type",
    "rdf:resource=\"http://purl.org/dc/dcmitype/StillImage\" />",
    "<dc:title></dc:title>",
    "</cc:Work>",
    "</rdf:RDF>",
    "</metadata>",
    "<text",
    "x=\""..X.."\"",
    "y=\""..Y.."\"",
    "text-anchor=\"middle\"",
    "id=\"maintext\"",
    "xml:space=\"preserve\"",
    "style=\"font-size:"..realFontSize.."px;font-style:normal;font-weight:normal;fill:#FF0000;font-family:"..font.."\">"..text.."</text>",
    "</svg>"
  }
  file:write(table.concat(template, "\n"))
  file:close()
  
  SKIN:Bang('[!Commandmeasure ScriptVectorConverter "ClearAllShapePath()"][!CommandMeasure Inkscape "Run"]')

end