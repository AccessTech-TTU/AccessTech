class Edge {
  final String vertex1;
  final String vertex2;
  final double weight;

  Edge(this.vertex1, this.vertex2, this.weight);
}

class UndirectedWeightedGraph {
  final Map<String, List<Edge>> _adjacencyList = {};

  void addVertex(String vertex) {
    if (!_adjacencyList.containsKey(vertex)) {
      _adjacencyList[vertex] = [];
    }
  }

  void addEdge(String vertex1, String vertex2, int weight) {
    addVertex(vertex1);
    addVertex(vertex2);

    final edge = Edge(vertex1, vertex2, weight);
    _adjacencyList[vertex1].add(edge);
    _adjacencyList[vertex2].add(edge); // Undirected graph, so we add the edge for both vertices
  }

  void printGraph() {
    _adjacencyList.forEach((vertex, edges) {
      print('$vertex -> ${edges.map((e) => '${e.vertex1}-${e.vertex2}:${e.weight}').join(', ')}');
    });
  }
}

void main() {
  final graph = UndirectedWeightedGraph();

  graph.addEdge('A', 'B', 5);
  graph.addEdge('B', 'C', 10);
  graph.addEdge('A', 'C', 8);

  graph.printGraph();
}
