{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01915') }},
        {{ ref('model_02054') }}
)
select id, 'model_02867' as name from sources
