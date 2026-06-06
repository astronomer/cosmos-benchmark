{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01079') }},
        {{ ref('model_00967') }},
        {{ ref('model_01042') }}
)
select id, 'model_01844' as name from sources
