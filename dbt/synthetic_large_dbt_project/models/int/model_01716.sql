{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01359') }},
        {{ ref('model_01300') }}
)
select id, 'model_01716' as name from sources
