{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01426') }},
        {{ ref('model_00942') }}
)
select id, 'model_01745' as name from sources
