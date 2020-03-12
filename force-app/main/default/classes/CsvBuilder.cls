public interface CsvBuilder {
	String Build();
	CsvBuilder AddCell(String cellValue);
	CsvBuilder AddCell(DateTime cellValue);
	CsvBuilder AddCell(Object cellValue);
	CsvBuilder AddCell();
	CsvBuilder AddBlankCells(Integer cellCount);
	CsvBuilder AddRow();
	CsvBuilder CloseRow();
}