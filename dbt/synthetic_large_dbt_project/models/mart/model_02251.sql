{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01588') }},
        {{ ref('model_02079') }},
        {{ ref('model_01974') }}
)
select id, 'model_02251' as name from sources
