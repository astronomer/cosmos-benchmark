{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00436') }},
        {{ ref('model_00176') }},
        {{ ref('model_00362') }}
)
select id, 'model_00793' as name from sources
