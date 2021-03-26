import { deployNozei } from "../helpers/migrations";

deployNozei("0xbd9c419003a36f187daf1273fce184e1341362c0")
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
