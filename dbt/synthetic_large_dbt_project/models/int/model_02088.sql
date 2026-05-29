{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00823') }},
        {{ ref('model_01098') }},
        {{ ref('model_00939') }}
)
select id, 'model_02088' as name from sources
