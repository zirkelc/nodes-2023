package example;

import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.neo4j.driver.Driver;
import org.neo4j.driver.GraphDatabase;
import org.neo4j.driver.Session;
import org.neo4j.harness.Neo4j;
import org.neo4j.harness.Neo4jBuilders;

import static org.assertj.core.api.Assertions.assertThat;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class JoinTest {

    private Neo4j embeddedDatabaseServer;

    @BeforeAll
    void initializeNeo4j() {
        this.embeddedDatabaseServer = Neo4jBuilders.newInProcessBuilder().withDisabledServer()
                .withFunction(Join.class).build();
    }

    @AfterAll
    void closeNeo4j() {
        this.embeddedDatabaseServer.close();
    }

    @Test
    void joinsStrings() {
        // This is in a try-block, to make sure we close the driver after the test
        try (Driver driver = GraphDatabase.driver(embeddedDatabaseServer.boltURI());
                Session session = driver.session()) {

            // When
            String result = session.run("RETURN example.join(['Hello', 'World']) AS result")
                    .single().get("result").asString();

            // Then
            assertThat(result).isEqualTo(("Hello,World"));
            // assertThat(result).isEqualTo(("World,Hello"));
        }
    }
}
