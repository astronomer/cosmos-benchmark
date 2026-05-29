{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01150') }},
        {{ ref('model_01353') }}
)
select id, 'model_02040' as name from sources
