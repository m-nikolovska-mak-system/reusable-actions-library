import fs from "fs-extra";
import yaml from "js-yaml";
import path from "path";

const WORKFLOW_DIR = ".github/workflows";
const OUTPUT_DIR = "docs/workflows";

function formatTable(rows, headers) {
  if (!rows || rows.length === 0) return "_None_";

  const headerRow = `| ${headers.join(" | ")} |`;
  const border = `| ${headers.map(() => "---").join(" | ")} |`;
  const body = rows
    .map(row => `| ${headers.map(h => row[h] ?? "").join(" | ")} |`)
    .join("\n");

  return `${headerRow}\n${border}\n${body}`;
}

function extractTriggers(on) {
  if (!on) return [];
  if (typeof on === "string") return [on];
  if (Array.isArray(on)) return on;
  return Object.keys(on);
}

function extractInputs(node) {
  return node?.inputs
    ? Object.entries(node.inputs).map(([name, info]) => ({
        name,
        type: info.type ?? "",
        required: info.required ? "yes" : "no",
        default: info.default ?? "",
        description: info.description ?? ""
      }))
    : [];
}

function extractSecrets(node) {
  return node?.secrets
    ? Object.entries(node.secrets).map(([name, info]) => ({
        name,
        required: info.required ? "yes" : "no",
        description: info.description ?? ""
      }))
    : [];
}

function extractOutputs(node) {
  return node?.outputs
    ? Object.entries(node.outputs).map(([name, info]) => ({
        name,
        description: info.description ?? ""
      }))
    : [];
}

function summarizeSteps(steps) {
  if (!steps) return [];
  return steps.map(s => ({
    name: s.name ?? (s.run ? "Run command" : s.uses ?? "Unnamed step"),
    action: s.uses ?? "",
    run: s.run ? "`run` command" : ""
  }));
}

async function generateDocs() {
  await fs.ensureDir(OUTPUT_DIR);

  const workflowFiles = fs
    .readdirSync(WORKFLOW_DIR)
    .filter(f => f.endsWith(".yml") || f.endsWith(".yaml"));

  for (const file of workflowFiles) {
    const fullPath = path.join(WORKFLOW_DIR, file);
    const yamlContent = yaml.load(fs.readFileSync(fullPath, "utf8"));

    const workflowName = yamlContent.name ?? file;
    const triggers = extractTriggers(yamlContent.on);
    const jobs = yamlContent.jobs ?? {};

    const inputs = extractInputs(yamlContent.on?.workflow_call);
    const outputs = extractOutputs(yamlContent.on?.workflow_call);
    const secrets = extractSecrets(yamlContent.on?.workflow_call);

    const md = [];

    // TITLE
    md.push(`# ${workflowName}`);
    md.push("");

    // SOURCE FILE
    md.push(`**Source:** \`${file}\``);
    md.push("");

    // TRIGGERS
    md.push("## Triggers");
    md.push(triggers.length ? triggers.map(t => `- \`${t}\``).join("\n") : "_None_");
    md.push("");

    // INPUTS
    md.push("## Inputs");
    md.push(formatTable(inputs, ["name", "type", "required", "default", "description"]));
    md.push("");

    // OUTPUTS
    md.push("## Outputs");
    md.push(formatTable(outputs, ["name", "description"]));
    md.push("");

    // SECRETS
    md.push("## Secrets");
    md.push(formatTable(secrets, ["name", "required", "description"]));
    md.push("");

    // JOBS
    md.push("## Jobs");
    for (const [jobName, job] of Object.entries(jobs)) {
      md.push(`### ${jobName}`);
      md.push("");
      const steps = summarizeSteps(job.steps);
      md.push(formatTable(steps, ["name", "action", "run"]));
      md.push("");
    }

    // YAML SOURCE
    md.push("## Full YAML");
    md.push("```yaml");
    md.push(fs.readFileSync(fullPath, "utf8"));
    md.push("```");

    // WRITE FILE
    const outputName = file.replace(/\.ya?ml$/, ".md");
    const outputPath = path.join(OUTPUT_DIR, outputName);

    await fs.writeFile(outputPath, md.join("\n"));

    console.log(`Generated docs for ${file}`);
  }
}

generateDocs();
