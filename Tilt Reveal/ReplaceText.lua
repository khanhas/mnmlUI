function replacetext()
  scale = tonumber(SKIN:GetVariable('Scale'))
  line1= string.lower(SKIN:GetMeasure('MeasureWeekDay'):GetStringValue())
  line2= string.lower(SKIN:GetMeasure('MeasureMonth'):GetStringValue())
  line3= string.lower(SKIN:GetMeasure('MeasureYear'):GetStringValue())
  font = SELF:GetOption('FontFace')
  fontsize = SKIN:ParseFormula('('..SELF:GetOption('FontSize')..')')
  realFontSize = math.ceil(fontsize*100/70)
  X = 200*scale
  Y = 150*scale
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
    "width=\"1920\"",
    "height=\"1080\"",
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
    "id=\"line1\"",
    "xml:space=\"preserve\"",
    "style=\"font-size:"..realFontSize.."px;font-style:normal;font-weight:normal;fill:#FF0000;font-family:"..font.."\">"..line1.."</text>",
    "<text",
    "x=\""..(X-50*scale).."\"",
    "y=\""..(Y+fontsize*11/10).."\"",
    "id=\"line2\"",
    "xml:space=\"preserve\"",
    "style=\"font-size:"..realFontSize.."px;font-style:normal;font-weight:normal;fill:#FF0000;font-family:"..font.."\">"..line2.."</text>",
    "<text",
    "x=\""..(X-80*scale).."\"",
    "y=\""..(Y+fontsize*2*11/10).."\"",
    "id=\"line3\"",
    "xml:space=\"preserve\"",
    "style=\"font-size:"..(realFontSize*4/5).."px;font-style:normal;font-weight:normal;fill:#FF0000;font-family:"..font.."\">"..line3.."</text>",
    "</svg>"
  }
  file:write(table.concat(template, "\n"))
  file:close()
  
  SKIN:Bang('[!Commandmeasure ScriptVectorConverter "ClearAllShapePath()"][!CommandMeasure Inkscape "Run"]')

end