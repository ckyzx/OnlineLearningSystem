using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using System.Xml.Linq;
using System.IO.Packaging;
using System.IO;
using System.Xml;

namespace OnlineLearningSystem.Utilities
{
    public static class OpenXmlHelper
    {

        public static List<DocxParagraph> GetDocxParagraphs(String filePath)
        {
            
            const string documentRelationshipType =
                "http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument";
            const string stylesRelationshipType =
                "http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles";
            const string wordmlNamespace =
                "http://schemas.openxmlformats.org/wordprocessingml/2006/main";
            XNamespace w = wordmlNamespace;

            XDocument xDoc = null;
            XDocument styleDoc = null;

            using (Package wdPackage = Package.Open(filePath, FileMode.Open, FileAccess.Read))
            {
                PackageRelationship docPackageRelationship =
                    wdPackage.GetRelationshipsByType(documentRelationshipType).FirstOrDefault();

                if (docPackageRelationship != null)
                {
                    // Resolve the Relationship Target Uri
                    // so the Document Part can be retrieved (expected /word/document.xml)
                    Uri documentUri = PackUriHelper.ResolvePartUri(new Uri("/", UriKind.Relative),
                        docPackageRelationship.TargetUri);
                    PackagePart documentPart = wdPackage.GetPart(documentUri);

                    // Load the style XML to the part into an XDocument instance.
                    xDoc = XDocument.Load(XmlReader.Create(documentPart.GetStream()));

                    // Find the style part. 
                    PackageRelationship styleRelation =
                        documentPart.GetRelationshipsByType(stylesRelationshipType)
                        .FirstOrDefault();
                    if (null != styleRelation)
                    {
                        Uri styleUri = PackUriHelper.ResolvePartUri(documentUri, styleRelation.TargetUri);
                        PackagePart stylePart = wdPackage.GetPart(styleUri);

                        // load the style XML in the part into an XDocument instance.
                        styleDoc = XDocument.Load(XmlReader.Create(stylePart.GetStream()));
                    }
                }
            }

            // <w:style w:type="paragraph" w:default="1" w:styleId="a">
            //  <w:name w:val="Normal" />
            //  <w:qFormat />
            // </w:style>
            // Get styleId, we can get "a" from the below sample xml
            string defaultStyle =
                (string)(from style in styleDoc.Root.Elements(w + "style")
                         where (string)style.Attribute(w + "type") == "paragraph" &&
                               (string)style.Attribute(w + "default") == "1"
                         select style)
                 .First().Attribute(w + "styleId");


            // Find all paragraphs in the document.
            var paragraphs =
                from para in xDoc
                             .Root
                             .Element(w + "body")
                             .Descendants(w + "p")
                let styleNode = para
                                .Elements(w + "pPr")
                                .Elements(w + "pStyle")
                                .FirstOrDefault()
                select new
                {
                    ParagraphNode = para,
                    StyleName = styleNode != null ? (string)styleNode.Attribute(w + "val") : defaultStyle
                };

            // Retrieve the text of each paragraph
            var paraWithText =
                from para in paragraphs
                select new
                {
                    StyleName = para.StyleName,
                    Text = ParagraphText(para.ParagraphNode)
                };

            return paraWithText.Select(para=>new DocxParagraph(){
                StyleName = para.StyleName,
                Text = para.Text
            }).ToList();

        }

        public static string ParagraphText(XElement e)
        {
            XNamespace w = e.Name.Namespace;
            return e
                    .Elements(w + "r")
                    .Elements(w + "t")
                    .StringConcatenate(element => (string)element);
        }

        public static string StringConcatenate(this IEnumerable<string> source)
        {
            StringBuilder sb = new StringBuilder();
            foreach (string s in source)
                sb.Append(s);
            return sb.ToString();
        }

        public static string StringConcatenate<T>(this IEnumerable<T> source,
            Func<T, string> func)
        {
            StringBuilder sb = new StringBuilder();
            foreach (T item in source)
                sb.Append(func(item));
            return sb.ToString();
        }

        public static string StringConcatenate(this IEnumerable<string> source, string separator)
        {
            StringBuilder sb = new StringBuilder();
            foreach (string s in source)
                sb.Append(s).Append(separator);
            return sb.ToString();
        }

        public static string StringConcatenate<T>(this IEnumerable<T> source,
            Func<T, string> func, string separator)
        {
            StringBuilder sb = new StringBuilder();
            foreach (T item in source)
                sb.Append(func(item)).Append(separator);
            return sb.ToString();
        }
    }
}