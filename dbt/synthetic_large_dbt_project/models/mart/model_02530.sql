{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01762') }},
        {{ ref('model_02197') }},
        {{ ref('model_02232') }}
)
select id, 'model_02530' as name from sources
