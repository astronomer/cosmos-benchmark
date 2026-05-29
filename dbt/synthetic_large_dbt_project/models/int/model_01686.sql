{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01150') }},
        {{ ref('model_00922') }},
        {{ ref('model_00829') }}
)
select id, 'model_01686' as name from sources
