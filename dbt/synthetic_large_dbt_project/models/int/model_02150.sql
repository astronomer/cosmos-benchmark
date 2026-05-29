{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01016') }},
        {{ ref('model_01043') }},
        {{ ref('model_01099') }}
)
select id, 'model_02150' as name from sources
