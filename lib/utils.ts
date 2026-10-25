type ClassValue = string | number | boolean | null | undefined | ClassValue[] | Record<string, unknown>;

export function cn(...values: ClassValue[]): string {
	const classes: string[] = [];

	const add = (value: ClassValue): void => {
		if (!value) return;

		if (typeof value === "string" || typeof value === "number") {
			classes.push(String(value));
		} else if (Array.isArray(value)) {
			value.forEach(add);
		} else if (typeof value === "object") {
			Object.entries(value).forEach(([name, enabled]) => {
				if (enabled) classes.push(name);
			});
		}
	};

	values.forEach(add);
	return classes.join(" ");
}
