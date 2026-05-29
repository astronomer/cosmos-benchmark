{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02103') }},
        {{ ref('model_01720') }},
        {{ ref('model_02112') }}
)
select id, 'model_02358' as name from sources
