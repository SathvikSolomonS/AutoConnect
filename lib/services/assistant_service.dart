class AssistantService {
  String respond(String query) {
    query = query.toLowerCase();

    if (query.contains('budget')) {
      return 'You can explore cars under ₹5–7 lakhs like hatchbacks.';
    } else if (query.contains('emi')) {
      return 'EMI depends on loan amount, interest and tenure.';
    } else if (query.contains('diesel') && query.contains('petrol')) {
      return 'Diesel gives better mileage, petrol is cheaper to maintain.';
    } else {
      return 'Ask me about budget, EMI, or car comparison.';
    }
  }
}
