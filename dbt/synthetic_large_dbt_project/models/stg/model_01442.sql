{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00620') }},
        {{ ref('model_00035') }},
        {{ ref('model_00678') }}
)
select id, 'model_01442' as name from sources
