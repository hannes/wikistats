import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Map;
import java.util.Map.Entry;
import java.util.TreeMap;

public class UglyAndCrudeWeekLengthCalculator {
	public static void main(String[] args) throws ParseException {

		Calendar c = Calendar.getInstance();
		DateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Map<Integer, Integer> daysInLastWeek = new TreeMap<Integer, Integer>();
		Map<Integer, Integer> daysInFirstWeek = new TreeMap<Integer, Integer>();
		Map<Integer, Integer> maxWeeks = new TreeMap<Integer, Integer>();

		for (int year = 2008; year <= Calendar.getInstance().get(Calendar.YEAR); year++) {
			daysInLastWeek.put(year, 0);
			daysInFirstWeek.put(year, 0);
			int maxWeek = -1;
			for (int day = 31; day > 10; day--) {
				String date = year + "-12-" + day;
				c.setTime(sdf.parse(date));
				int week = c.get(Calendar.WEEK_OF_YEAR);
				if (week == 1) {
					continue;
				}
				if (week > maxWeek) {
					maxWeek = week;
				}
				if (week == maxWeek) {
					daysInLastWeek.put(year, daysInLastWeek.get(year) + 1);
				}
				maxWeeks.put(year, maxWeek);
			}

			for (int day = 1; day < 10; day++) {
				String date = year + "-01-" + day;
				c.setTime(sdf.parse(date));
				int week = c.get(Calendar.WEEK_OF_YEAR);
				if (week == 1) {
					daysInFirstWeek.put(year, daysInFirstWeek.get(year) + 1);
				}
			}
		}
		System.out.println("First Week");
		for (Entry<Integer, Integer> res : daysInFirstWeek.entrySet()) {
			System.out.println(res.getKey() + ": " + res.getValue());
		}
		System.out.println("Last Week");
		for (Entry<Integer, Integer> res : daysInLastWeek.entrySet()) {
			System.out.println(res.getKey() + ": " + res.getValue() + " ("
					+ maxWeeks.get(res.getKey()) + ")");
		}

	}

}
