{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00323') }},
        {{ ref('model_00705') }}
)
select id, 'model_01035' as name from sources
