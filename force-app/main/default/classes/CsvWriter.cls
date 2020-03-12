public with sharing class CsvWriter implements CsvBuilder {
	/*----------------
	-  Constructors  -
	----------------*/

	public CsvWriter() {
		writerOptions = new Options();
	}
	public CsvWriter(Options userOptions){
		writerOptions = userOptions;
	}

	/*------------------
	-  Public members  -
	------------------*/

	public Options writerOptions;

	/*------------------
	-  Public methods  -
	------------------*/
	
	public String Build(){
		return rows == null
			? ''
			: String.Join(rows, '\n');
	}

	public CsvBuilder AddCell(String cellValue){
		cellValue = cellValue == null ? '' : cellValue;
		if (currentRow == null) throw new CsvWriterException('Can\'t add cell when no row is active. Call AddRow() first.');
		currentRow.Add(EscapedCellValue(cellValue));
		return this;
	}

	// stephan.spiegel:02018-09-13-Thu Removed override for Date; somehow Dates are sent to the DateTime override...

	public CsvBuilder AddCell(Datetime cellValue){
		String cellValueAsString = cellValue == null ? '' : cellValue.format(writerOptions.dateformat, writerOptions.dateTimeZone);
		return AddCell(cellValueAsString);
	}

	public CsvBuilder AddCell(Object cellValue){
		return AddCell(String.valueOf(cellValue));
	}

	public CsvBuilder AddCell(){
		return AddCell('');
	}

	public CsvBuilder AddBlankCells(Integer cellCount) {
		for(Integer i = 0; i < cellCount; i++){
			AddCell();
		}
		return this;
	}

	public CsvBuilder AddRow(){
		if (currentRow != null) throw new CsvWriterException('Can\'t add row when one is already active. Call CloseRow() before adding another.');
		currentRow = new List<String>();
		return this;
	}

	public CsvBuilder CloseRow(){
		if (currentRow == null || currentRow.Size() < 1) throw new CsvWriterException('Can\'t close row. Call AddRow() and add some cell values with AddCell() first.');
		if (rows == null) {
			rows = new List<String>();
			columnCount = currentRow.Size();
		} else {
			if (currentRow.Size() != columnCount) throw new CsvWriterException('Row '+ (rows.Size()+1).format() + ' has '+currentRow.Size()+' cells instead of the expected '+columnCount+'.');
		}
		rows.Add(String.Join(currentRow, writerOptions.delimiter));
		currentRow = null;
		return this;
	}

	/*--------------------
	-  Internal classes  -
	--------------------*/

	public class Options {
		public Boolean replaceLiteralNulls {get; set;}
		public Boolean trimWhiteSpace {get; set;}
		public String delimiter {get; set;}
		public String dateFormat {get;set;}
		public String dateTimeZone {get;set;}
		public Options() {
			replaceLiteralNulls = true;
			trimWhiteSpace = false;
			delimiter = ',';
			dateFormat = 'MM/dd/yyyy';
			dateTimeZone = 'PDT';
		}
	}

	public class CsvWriterException extends Exception {}

	/*-------------------
	-  Private members  -
	-------------------*/
	
	private List<String> rows;
	private List<String> currentRow;
	private Integer columnCount;

	/*-------------------
	-  Private methods  -
	-------------------*/
	
	private static Boolean CellValueNeedsToBeQuoted(String cellValue){
		if (String.isBlank(cellValue)) return false;
		return cellValue.containsAny('",\r\n');
	}

	private String EscapedCellValue(String cellValue){
		cellValue = writerOptions.replaceLiteralNulls ? RemoveLiteralNull(cellValue) : cellValue;
		cellValue = RemoveScientificNotation(cellValue);
		cellValue = writerOptions.trimWhiteSpace ? cellValue.normalizeSpace() : cellValue;
		return CellValueNeedsToBeQuoted(cellValue) ?  QuotedCellValue(cellValue) : cellValue;
	}

	private static String RemoveLiteralNull(String cellValue){
		if (cellValue.toLowerCase() == 'null'){
			return '';
		}
		return cellValue;
	}

	private static String RemoveScientificNotation(String cellValue){
			return cellValue.replace('0E-8', '0');
	}

	private static String QuotedCellValue(String cellValue){
		return '"'+DoubleUpQuotes(cellValue)+'"';
	}

	private static String DoubleUpQuotes(String cellValue){
		return cellValue.replace('"','""');
	}

}