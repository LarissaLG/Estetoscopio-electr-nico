import mlreportgen.dom.*;

% Create a new PDF document
doc = Document('example_report', 'pdf');

% Add a title
title = Paragraph('My MATLAB PDF Report');
title.Bold = true;
title.FontSize = '18pt';
append(doc, title);

% Add some text
text = Paragraph('This is an example PDF generated in MATLAB.');
append(doc, text);

% Add an image (optional)
image = Image('auscu.jpg'); % Replace with your image file
append(doc, image);

% Add a table
data = {'Header1', 'Header2'; 1, 2; 3, 4};
table = Table(data);
table.Style = {Border('solid', 'black', '1px')};
append(doc, table);

% Finalize and close the document
close(doc);

% Open the PDF
rptview(doc.OutputPath);
